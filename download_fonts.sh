#!/bin/bash
mkdir -p assets/fonts
cd assets/fonts

# Download Poppins fonts
wget -O Poppins-Regular.ttf "https://github.com/google/fonts/raw/main/ofl/poppins/Poppins-Regular.ttf"
wget -O Poppins-Medium.ttf "https://github.com/google/fonts/raw/main/ofl/poppins/Poppins-Medium.ttf"
wget -O Poppins-Bold.ttf "https://github.com/google/fonts/raw/main/ofl/poppins/Poppins-Bold.ttf"