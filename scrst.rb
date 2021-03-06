class Scrst < Formula
  homepage "https://github.com/dreadatour/scrst"
  url "https://github.com/dreadatour/scrst/archive/1.1.1.tar.gz"
  version "1.1.1"
  sha256 "57d6ca9de55de7c3f136cbd7c275fcb08af350ce85fb521122a75869112ed252"
  head "https://github.com/dreadatour/scrst.git", :branch => "master"

  depends_on "terminal-notifier" => :recommended
  depends_on :python if MacOS.version <= :snow_leopard

  resource "pillow" do
    url "https://pypi.python.org/packages/source/P/Pillow/Pillow-2.8.2.tar.gz"
    sha256 "2caf5b992bdbe67e05084658b783d4dcb9cf7becda3794d95c89e0575c453c3a"
  end

  resource "boto" do
    url "https://pypi.python.org/packages/source/b/boto/boto-2.38.0.tar.gz"
    sha256 "d9083f91e21df850c813b38358dc83df16d7f253180a1344ecfedce24213ecf2"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"

    resource("pillow").stage do
      inreplace "setup.py", "'brew', '--prefix'", "'#{HOMEBREW_PREFIX}/bin/brew', '--prefix'"
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end

    resource("boto").stage do
      system "python", *Language::Python.setup_install_args(libexec/"vendor")
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])

    prefix.install Dir["services"]
    prefix.install Dir["screenshot.dzbundle"]
  end

  def caveats; <<-EOS.undent
    Please, run
      /usr/local/bin/scrst --setup
    to configure program.
    EOS
  end
end
