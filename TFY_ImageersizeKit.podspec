

Pod::Spec.new do |spec|

  spec.name         = "TFY_ImageersizeKit"

  spec.version      = "2.1.0"
  
  spec.summary      = "相机获取和裁剪图片"

  spec.description  = <<-DESC
  相机获取和裁剪图片
                   DESC

  spec.homepage     = "https://github.com/13662049573/TFY_ImageresizerView"
  
  spec.license      = "MIT"
  
  spec.author       = { "tfyzxc13662049573" => "420144542@qq.com" }
  

  spec.source       = { :git => "https://github.com/13662049573/TFY_ImageresizerView.git", :tag => spec.version }

  spec.source_files  =  "TFY_ImageresizerView/TFY_ImageersizeKit/TFY_ImageersizeHeader.h"
  
  spec.platform     = :ios, "10.0"
  
  spec.subspec 'TFY_ImageSizeTools' do |s|
    s.source_files  = "TFY_ImageresizerView/TFY_ImageersizeKit/TFY_ImageSizeTools/**/*.{h,m}"
  end
  
  spec.requires_arc = true

end
