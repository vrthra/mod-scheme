rm cscope.*
find . -type f -name "*.[hc]" -print | grep -v ".OBJ" > cscope.files
find . -type f -name "*.cpp" -print | grep -v ".OBJ" >> cscope.files
find . -type f -name "*.cc" -print | grep -v ".OBJ" >> cscope.files
find . -type f -name "*.hpp" -print | grep -v ".OBJ" >> cscope.files
cscope -b
