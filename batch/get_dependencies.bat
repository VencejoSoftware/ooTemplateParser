@echo off

if not exist %delphiooLib%\ooBatch\ (
  @echo "Clonning ooBatch..."
  git clone https://github.com/VencejoSoftware/ooBatch.git %delphiooLib%\ooBatch\
  call %delphiooLib%\ooBatch\code\get_dependencies.bat
)

if not exist %delphiooLib%\ooText\ (
  @echo "Clonning ooText..."
  git clone https://github.com/VencejoSoftware/ooText.git %delphiooLib%\ooText\
  call %delphiooLib%\ooText\batch\get_dependencies.bat
)

if not exist %delphiooLib%\ooParser\ (
  @echo "Clonning ooParser..."
  git clone https://github.com/VencejoSoftware/ooParser.git %delphiooLib%\ooParser\
  call %delphiooLib%\ooParser\batch\get_dependencies.bat
)