# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'SimpleDocbase' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for SimpleDocbase
  pod 'SVProgressHUD'
  pod 'SwiftyFORM'
  pod 'SwiftyMarkdown'

end

post_install do | installer |
  require 'fileutils'

  FileUtils.cp_r('Pods/Target Support Files/Pods-SimpleDocbase/Pods-SimpleDocbase-acknowledgements.plist', 'SimpleDocbase/Settings.bundle/Acknowledgements.plist', :remove_destination => true)

end
