all: libprocesshider.so

libprocesshider.so: processhider.c
	gcc -Wall -fPIC -shared -o libprocesshider.so processhider.c -ldl

.PHONY clean:
	rm -f libprocesshider.so

.PHONY config:
	@echo "Enter the name of the process you want to hide (e.g. python): "\ read INPUT; \ @echo "Configured file to replace $$(INPUT); \sed "s/REPLACEME/$$(INPUT)
