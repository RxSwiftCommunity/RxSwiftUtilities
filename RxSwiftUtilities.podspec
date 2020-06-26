Pod::Spec.new do |s|
  s.name         = "RxSwiftUtilities"
  s.version      = "2.2.0"
  s.summary      = "Helpful classes and extensions for RxSwift"
  s.description  = <<-DESC
Helpful classes and extensions for RxSwift which don't belong in RxSwift core.
                   DESC
  s.homepage     = "https://github.com/RxSwiftCommunity/RxSwiftUtilities"
  s.license      = { :type => "MIT", :file => "LICENSE.md" }
  s.author       = { "Jesse Farless" => "solidcell@gmail.com" }
  s.swift_version = "5.0"
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.10"
  s.tvos.deployment_target = "9.0"
  s.watchos.deployment_target = "3.0"
  s.source       = { :git => "https://github.com/RxSwiftCommunity/RxSwiftUtilities.git", :tag => "#{s.version}" }
  s.source_files = 'Source/Common/*.swift'
  s.ios.source_files = 'Source/iOS/*.swift'
  s.dependency   "RxSwift", "~> 5.1"
  s.dependency   "RxCocoa", "~> 5.1"
end
