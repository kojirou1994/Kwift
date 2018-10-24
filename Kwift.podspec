Pod::Spec.new do |s|
  s.name         = "Kwift"
  s.version      = "0.0.1"
  s.summary      = "Personal swift extensions."
  s.homepage     = "https://github.com/kojirou1994/Kwift"
  s.license      = "MIT"
  s.author             = { "Kojirou" => "Kojirouhtc@gmail.com" }
  s.ios.deployment_target = "10.0"
  s.osx.deployment_target = "10.10"
  s.source       = { :git => "https://github.com/kojirou1994/Kwift", :tag => "#{s.version}" }
  s.source_files  = "Sources/Kwift/*.swift"
  s.swift_version = "4.2"
end
