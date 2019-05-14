Pod::Spec.new do |spec|
	spec.name                       = "Dynamism"
	spec.version                    = "0.0.1"
	
	spec.summary                    = "Dynamic systems framework for Swift."
	spec.description                = <<-DESC
		A Swift framework that enables creation of dynamic systems based on an assortment of utilities that are sorely missing from the Swift runtime.
	DESC
	
	spec.homepage                   = "https://github.com/technogen-gg/Dynamism.git"
	spec.license                    = { :type => "Unlicense", :file => "LICENCE.txt" }
	spec.authors                    = { "Gor Gyolchanyan" => "gor.zone@icloud.com" }
	
	spec.source                     = { :git => "https://github.com/technogen-gg/Dynamism.git", :tag => "#{spec.version}" }
	spec.source_files               = "Sources", "Sources/**/*.{swift,h,c,cpp,m,mm}"
	
	spec.osx.deployment_target      = '10.9'
	spec.ios.deployment_target      = '8.0'
	spec.tvos.deployment_target     = '9.0'
	spec.watchos.deployment_target  = '2.0'
	
	spec.swift_version = "5.0"
	spec.requires_arc = true
	spec.xcconfig = {  }
end
