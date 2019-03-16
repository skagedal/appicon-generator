help = <<ENDHELP
This Rakefile specifies various development and maintainence tasks for appicon-generator.

To make a release of version 0.99:

   rake "release[0.99]"

ENDHELP

# Constants

VERSION_SWIFT = "./Sources/AppIconGeneratorCore/Version.swift"
DOT_VERSION = "./.version"

# Tasks

task default: [:info]

task :info do
    puts help
end

task :release, [:version] do |t, args| 
    unless git_is_clean? || should_force?
        abort("Please commit changes to git first.")
    end
    version = args.version
    puts "Setting version number #{version}"
    write_version_swift(version)
    write_dot_version(version)
    system('git', 'commit', '-a', '-m', version)
    system('git', 'tag', '-a', version, '-m', version)
end

# Helpers

def write_version_swift(version)
    File.write(VERSION_SWIFT, <<EOF)
// 
// This file is generated by a rake script.
//

public extension AppIconGenerator {
    static var version: String {
        return "#{version}"
    }
}
EOF
end

def write_dot_version(version)
    File.write(DOT_VERSION, version)
end

def abort(message)
    puts message
    exit 1
end

def git_is_clean? 
    `git status --porcelain`.empty?
end

def should_force?
    ENV["FORCE"] == "yes"
end
