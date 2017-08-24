import os
import ycm_core
import shlex
import subprocess

def PkgConfig(args):
  cmd = ['pkg-config'] + shlex.split(args)
  out = subprocess.Popen(cmd, shell=False, stdout=subprocess.PIPE).stdout
  line = out.readline()[:-1].split(" ")
  return filter(lambda a: a != ' ', line)

flags = [
'-Wall',
'-Wextra',
'-Werror',
'-Wno-long-long',
'-Wno-variadic-macros',
'-Wno-unused-parameter',
'-Wno-deprecated-declarations',
'-fexceptions',
'-DNDEBUG',
'-DUSE_CLANG_COMPLETER',
'-std=c++11',
'-x',
'c++',
'-I',
'.',
'-I',
'/usr/include',
'-I',
'/usr/include/llvm',
'-DHAVE_CONFIG_H',
'-DPACKAGE_DATA_DIR="/usr/local/share"',
'-DPACKAGE_LOCALE_DIR="/usr/local/share/locale"'
]

flags += PkgConfig("--cflags x11")
flags += PkgConfig("--cflags glib-2.0")
flags += PkgConfig("--cflags gtk+-3.0")
flags += PkgConfig("--cflags alsa")
flags += PkgConfig("--cflags libnotify")
flags += PkgConfig("--cflags opencv")

flags += PkgConfig("--libs x11")
flags += PkgConfig("--libs glib-2.0")
flags += PkgConfig("--libs gtk+-3.0")
flags += PkgConfig("--libs alsa")
flags += PkgConfig("--libs libnotify")
flags += PkgConfig("--libs opencv")


# SOURCE_EXTENSIONS = ['.hpp', '.cpp', '.cxx', '.cc', '.c', '.m', '.mm' ]

compilation_database_folder = ''

if compilation_database_folder:
  database = ycm_core.CompilationDatabase( compilation_database_folder )
else:
  database = None


def DirectoryOfThisScript():
  return os.path.dirname( os.path.abspath( __file__ ) )


def MakeRelativePathsInFlagsAbsolute( flags, working_directory ):
  if not working_directory:
    return list( flags )
  new_flags = []
  make_next_absolute = False
  path_flags = [ '-isystem', '-I', '-iquote', '--sysroot=' ]
  for flag in flags:
    new_flag = flag

    if make_next_absolute:
      make_next_absolute = False
      if not flag.startswith( '/' ):
        new_flag = os.path.join( working_directory, flag )

    for path_flag in path_flags:
      if flag == path_flag:
        make_next_absolute = True
        break

      if flag.startswith( path_flag ):
        path = flag[ len( path_flag ): ]
        new_flag = path_flag + os.path.join( working_directory, path )
        break

    if new_flag:
      new_flags.append( new_flag )
  return new_flags


def FlagsForFile( filename ):
  if database:
    compilation_info = database.GetCompilationInfoForFile( filename )
    final_flags = MakeRelativePathsInFlagsAbsolute(
      compilation_info.compiler_flags_,
      compilation_info.compiler_working_dir_ )

    try:
      final_flags.remove( '-stdlib=libc++' )
    except ValueError:
      pass
  else:
    relative_to = DirectoryOfThisScript()
    final_flags = MakeRelativePathsInFlagsAbsolute( flags, relative_to )

  return {
    'flags': final_flags,
    'do_cache': True
  }
