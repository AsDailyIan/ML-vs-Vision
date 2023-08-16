# Uncomment the next line to define a global platform for your project
platform :ios, '16.2'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = "arm64"
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.2'
    end
  end
end

target 'AI_Comparison' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
	
  # To recognize Latin script
  pod 'GoogleMLKit/TextRecognition', '3.2.0'
  # To recognize Chinese script
  pod 'GoogleMLKit/TextRecognitionChinese', '3.2.0'
  # To recognize Devanagari script
  pod 'GoogleMLKit/TextRecognitionDevanagari', '3.2.0'
  # To recognize Japanese script
  pod 'GoogleMLKit/TextRecognitionJapanese', '3.2.0'
  # To recognize Korean script
  pod 'GoogleMLKit/TextRecognitionKorean', '3.2.0'

  # Pods for AI_Comparison

  target 'AI_ComparisonTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'AI_ComparisonUITests' do
    # Pods for testing
  end

end
