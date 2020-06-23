

Pod::Spec.new do |spec|

  spec.name         = "TFY_ImageersizeKit"
  spec.version      = "2.0.0"
  spec.summary      = "相机获取和裁剪图片"

  spec.description  = <<-DESC
  相机获取和裁剪图片
                   DESC

  spec.homepage     = "https://github.com/13662049573/TFY_ImageresizerView"
  
  spec.license      = "MIT"
  
  spec.author       = { "tfyzxc13662049573" => "420144542@qq.com" }
  

  spec.source       = { :git => "https://github.com/13662049573/TFY_ImageresizerView.git", :tag => spec.version }

  spec.source_files  =  "TFY_ImageresizerView/TFY_ImageersizeKit/**/*.{h,m}","TFY_ImageresizerView/TFY_ImageersizeKit/TFY_ImageersizeHeader.h"
  
  spec.ios.deployment_target = '10.0' 
  
  spec.subspec 'TFY_ImageSizeTools' do |s|
    s.source_files  = "TFY_ImageresizerView/TFY_ImageersizeKit/TFY_ImageSizeTools/**/*.{h,m}"
  end

  spec.subspec 'TFY_ImageController' do |s|
    s.dependency "TFY_ImageersizeKit/TFY_ImageSizeTools"
    s.source_files  = "TFY_ImageresizerView/TFY_ImageersizeKit/TFY_ImageController/**/*.{h,m}"
    
  end

  spec.subspec 'TFY_imagebundle' do |s|
    s.resources     = "TFY_ImageresizerView/TFY_ImageersizeKit/TFY_imagebundle"
  end

  spec.xcconfig      = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include" }
  
  spec.requires_arc = true

end
