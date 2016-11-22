Pod::Spec.new do |s|
  s.name         = "RxSwiftUtilities"
  s.version      = "0.0.1"
  s.summary      = "Helpful classes and extensions for RxSwift"
  s.description  = <<-DESC
Helpful classes and extensions for RxSwift which don't belong in RxSwift core.
                   DESC
  s.homepage     = "https://github.com/solidcell/RxSwiftUtilities"
  s.license      = { :type => "MIT", :file => "LICENSE.md" }
  s.author       = { "Jesse Farless" => "solidcell@gmail.com" }
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/solidcell/RxSwiftUtilities.git", :tag => "#{s.version}" }
  s.source_files = 'Source/*.swift'
  s.dependency   "RxSwift", "~> 3.0.1"
  s.dependency   "RxCocoa", "~> 3.0.1"
end
