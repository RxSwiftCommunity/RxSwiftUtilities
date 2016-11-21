Pod::Spec.new do |s|
  s.name         = "RxSwiftUtilities"
  s.version      = "0.0.1"
  s.summary      = "Example summary."
  s.description  = <<-DESC
Example description
                   DESC
  s.homepage     = "http://www.example.com"
  s.license      = "MIT"
  s.author       = { "Jesse Farless" => "solidcell@gmail.com" }
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/solidcell/RxSwiftUtilities.git", :tag => "#{s.version}" }
  s.source_files = 'Source/*.swift'
  s.dependency   "RxSwift", "~> 3.0.1"
end
