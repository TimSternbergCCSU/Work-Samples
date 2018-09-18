#include <Python.h>
#include <stdio.h>

// sudo g++ -Wall -I /usr/include/python3.5m/ -lpython3.5m CallFPScanner.cpp -o CallFPScanner.out

int main(int argc, char *argv[]) {
  FILE * fp;
  fp = fopen("/home/pi/Desktop/fingerprint/Final/mode.txt","w");
  fprintf(fp,argv[1]);
  fclose(fp);

  wchar_t *program = Py_DecodeLocale(argv[0], NULL);
  Py_SetProgramName(program);  /* optional but recommended */
  Py_Initialize();
  PyObject *obj = Py_BuildValue("s", "FP_Python.py");
  FILE *file = _Py_fopen_obj(obj, "r+");
  if(file != NULL) {
      PyRun_SimpleFile(file, "FP_Python.py");
  }
  PyMem_RawFree(program);
  return 0;
}
