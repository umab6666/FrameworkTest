#
#  Be sure to run `pod spec lint FrameworkTest.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "FrameworkTest"
  s.version      = "1.0.0"
  s.summary      = "A short description of FrameworkTest.(API Calling through NSURLSessions)"

  
  s.description  =  "A short description of FrameworkTest.(API Calling through NSURLSessions)"

  s.homepage     = "http://EXAMPLE/FrameworkTest"
 
  s.license      = "MIT"
 
  s.author             = { "uma@thisisswitch.in" => "uma@thisisswitch.in" }
 
  
   s.platform     = :ios, "12.0"

  
 
  s.source       = { :git => "https://github.com/umab6666/FrameworkTest.git", :tag => "1.0.0" }


 
  s.source_files  = "FrameworkTest"
  s.swift_version = '4.2'

 end
