Pod::Spec.new do |s|
  s.name         = "RxSwiftUtilities"
  s.version      = "1.0.1"
  s.summary      = "Helpful classes and extensions for RxSwift"
  s.description  = <<-DESC
Helpful classes and extensions for RxSwift which don't belong in RxSwift core.
                   DESC
  s.homepage     = "https://github.com/RxSwiftCommunity/RxSwiftUtilities"
  s.license      = { :type => "MIT", :file => "LICENSE.md" }
  s.author       = { "Jesse Farless" => "solidcell@gmail.com" }
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.10"
  s.tvos.deployment_target = "9.0"
  s.watchos.deployment_target = "2.0"
  s.source       = { :git => "https://github.com/RxSwiftCommunity/RxSwiftUtilities.git", :tag => "#{s.version}" }
  s.source_files = 'Source/*.swift'
  s.dependency   "RxSwift", "~> 3.0"
  s.dependency   "RxCocoa", "~> 3.0"
end
