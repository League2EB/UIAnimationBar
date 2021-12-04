Pod::Spec.new do |s|
  s.name             = 'UIAnimationBar'
  s.version          = '1.0.0'
  s.summary          = '導航欄帶搜尋框過度動畫'


  s.description      = <<-DESC
  《本草綱目》是一部集中國16世紀以前本草學大成的著作，明代萬曆六年定稿，萬曆二十三年在南京正式刊行，作者為中國歷史上最著名的醫學家、藥學家和博物學家之一李時珍。在《四庫全書》中為子部醫家類。 《本草綱目》從完稿至刻印經歷了十多年時間。李時珍到過蘄州、黃州和武昌，都沒有書商願意承印。
                       DESC

  s.homepage         = 'https://github.com/League2EB/UIAnimationBar'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'League2eb' => 'info@league2eb.me' }
  s.source           = { :git => 'https://github.com/League2EB/UIAnimationBar.git', :tag => s.version.to_s }
  s.swift_version = '5.0'
  s.ios.deployment_target = '13.0'

  s.source_files = 'UIAnimationBar/Classes/**/*'
  
  s.resource_bundles = {
  'UIAnimationBarResource' => ['UIAnimationBar/Assets/*.{png,xib,xcassets}']
  }

   s.dependency 'DeviceKit'
end
