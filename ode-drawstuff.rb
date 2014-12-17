require 'formula'

class Ode < Formula
  url 'http://sourceforge.net/projects/opende/files/ODE/0.13/ode-0.13.tar.bz2'
  homepage 'http://www.ode.org/'
  sha1 '93930249a503ce8d09aee1f50be54c7c7f18d7e113f4be3d78ae947b3bbfef17'

  depends_on 'pkg-config' => :build
  depends_on 'gnu-sed' => :build

  if ARGV.build_head?
    # Requires newer automake and libtool
    depends_on 'automake' => :build
    depends_on 'libtool' => :build
  end

  def options
    [
      ["--enable-double-precision", "Configure ODE to work with double precision"],
      ["--enable-libccd", "Enable all libccd colliders (except box-cylinder)"],
      ["--with-drawstuff", "Build and install Drawstuff"]
    ]
  end

  def install
    args = []
    args << "--enable-double-precision" if ARGV.include? "--enable-double-precision"
    args << "--enable-libccd" if ARGV.include? "--enable-libccd"

    if ARGV.build_head?
      ENV['LIBTOOLIZE'] = 'glibtoolize'
      inreplace 'autogen.sh', 'libtoolize', '$LIBTOOLIZE'
      system "./autogen.sh"
    end
    system "./configure", "--prefix=#{prefix}", *args
    system "make"
    system "make install"
    if(ARGV.include?("--with-drawstuff"))
      system "curl -O https://raw.github.com/gist/3225621/install_drawstuff.sh"
      system "chmod a+x install_drawstuff.sh"
      system "./install_drawstuff.sh"
    end
  end
end
