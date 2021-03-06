#!/usr/bin/python

from __future__ import print_function
from optparse import OptionParser

import os

languages_hpp_template = """\
#pragma once

#include "std/array.hpp"
#include "std/string.hpp"

// This file is autogenerated while exporting sounds.csv from the google table.
// It contains the list of languages which can be used by TTS.
// It shall be included to Android(jni) and iOS part to get the languages list.

namespace routing
{{
namespace turns
{{
namespace sound
{{
array<string, {lang_list_size}> const kLanguageList = 
{{{{
{lang_list}
}}}};
}}  // namespace sound
}}  // namespace turns
}}  // namespace routing
"""

def parse_args():
  opt_parser = OptionParser(usage="This tool creates directories for languages for twine."
    + "All directory names shall be listed in languages file with space separator.\n"
    + "Example: python %prog path_to_language.txt path_to_languages.hpp path_to_dir_with_json_files", 
    version="%prog 1.0")

  (options, args) = opt_parser.parse_args()

  if len(args) != 3:
    opt_parser.error("Wrong number of arguments.")
  return args

def make_language_dirs(langs_name, json_dir_name):
  print ("Creating directories for languages in json.")
  with open(langs_name, "r") as langs_file:
    for lang in langs_file.read().split():
      new_dir = os.path.join(json_dir_name, lang + ".json")
      if not os.path.exists(new_dir):
        os.makedirs(new_dir)

def make_languages_hpp(langs_name, hpp_name):
  print ("Creating {fine_name}".format(fine_name = hpp_name))
  with open(langs_name, 'r') as langs_file:
    languages_list = langs_file.read().split()
    languages_list.sort()
    lang_str = ",\n".join(["  \"{}\"".format(language) for language in languages_list])
    with open(hpp_name, "w") as hpp_file:
      hpp_file.write(languages_hpp_template.format(lang_list_size = len(languages_list), lang_list = lang_str))

def run():
  langs_name, langs_hpp_name, json_dir_name = parse_args()
  make_language_dirs(langs_name, json_dir_name)
  make_languages_hpp(langs_name, langs_hpp_name)

if __name__ == "__main__":
  run()
