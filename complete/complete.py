# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this file,
# You can obtain one at http://mozilla.org/MPL/2.0/.
#
# Copyright (c) 2013, Paul Fultz II

from ctypes import cdll
from ctypes import c_int
from ctypes import c_char_p
from ctypes import c_void_p
from ctypes import c_uint
from ctypes import py_object
from copy import copy
import os
import platform
current_path = os.path.dirname(os.path.abspath(__file__))
suffix = 'so'
if platform.system() == 'Darwin':
    suffix = 'dylib'
elif platform.system() == 'Windows':
    suffix = 'dll'
complete = cdll.LoadLibrary('%s/libcomplete.%s' % (current_path, suffix))

#
#
# Clang c api wrapper
#
#

complete.clang_complete_string_list_len.restype = c_int
complete.clang_complete_string_list_at.restype = c_char_p
complete.clang_complete_string_value.restype = c_char_p
complete.clang_complete_find_uses.restype = c_uint
complete.clang_complete_get_completions.restype = c_uint
complete.clang_complete_get_diagnostics.restype = c_uint
complete.clang_complete_get_definition.restype = c_uint
complete.clang_complete_get_type.restype = c_uint

def convert_to_c_string_array(a):
    result = (c_char_p * len(a))()
    result[:] = [x.encode('utf-8') for x in a]
    return result

def convert_string_list(l):
    result = [complete.clang_complete_string_list_at(l, i).decode('utf-8') for i in range(complete.clang_complete_string_list_len(l))]
    complete.clang_complete_string_list_free(l)
    return result

def convert_string(s):
    result = complete.clang_complete_string_value(s).decode('utf-8')
    complete.clang_complete_string_free(s)
    return result

def find_uses(filename, args, line, col, file_to_search):
    search = None
    if file_to_search is not None: search = file_to_search.encode('utf-8')
    return convert_string_list(complete.clang_complete_find_uses(filename.encode('utf-8'), convert_to_c_string_array(args), len(args), line, col, search))

def get_completions(filename, args, line, col, prefix, timeout, unsaved_buffer):
    if unsaved_buffer is None and not os.path.exists(filename): return []
    buffer = None
    if (unsaved_buffer is not None): buffer = unsaved_buffer.encode("utf-8")
    buffer_len = 0
    if (buffer is not None): buffer_len = len(buffer)

    return convert_string_list(complete.clang_complete_get_completions(filename.encode('utf-8'), convert_to_c_string_array(args), len(args), line, col, prefix.encode('utf-8'), timeout, buffer, buffer_len))

def get_diagnostics(filename, args):
    return convert_string_list(complete.clang_complete_get_diagnostics(filename.encode('utf-8'), convert_to_c_string_array(args), len(args)))

def get_definition(filename, args, line, col):
    return convert_string(complete.clang_complete_get_definition(filename.encode('utf-8'), convert_to_c_string_array(args), len(args), line, col))

def get_type(filename, args, line, col):
    return convert_string(complete.clang_complete_get_type(filename.encode('utf-8'), convert_to_c_string_array(args), len(args), line, col))

def reparse(filename, args, unsaved_buffer):
    buffer = None
    if (unsaved_buffer is not None): buffer = unsaved_buffer.encode("utf-8")
    buffer_len = 0
    if (buffer is not None): buffer_len = len(buffer)

    complete.clang_complete_reparse(filename.encode('utf-8'), convert_to_c_string_array(args), len(args), buffer, buffer_len)

def free_tu(filename):
    complete.clang_complete_free_tu(filename.encode('utf-8'))

def free_all():
    complete.clang_complete_free_all()
