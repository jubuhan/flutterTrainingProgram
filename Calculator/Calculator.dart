import 'dart:io';

double operation(double num1,String op,double num2){
  double result=0;
  switch(op){
    case '+':
    result=num1+num2;
    break;
    case '-':
    result=num1-num2;
    break;
    case '*':
    result=num1*num2;
    break;
    case '/':
    if(num2==0){
      print("DIVISION BY ZERO");
      return double.nan;
    }else{
      result=num1/num2;
    }
    break;
    default:
    print("invalid operator");
    return double.nan;
  }

  return result;
}

void main(){
  
  print("enter the 1st number");
  double num1=double.parse(stdin.readLineSync()!);
  while(true){
    print("enter the operator('+'|'-'|'*'|'/'|'exit')");
  String operator=stdin.readLineSync()!;
  if(operator=='exit'){
    
    break;                     }
  print("enter the next number");
  double num2=double.parse(stdin.readLineSync()!);
  double result=operation(num1, operator, num2);
  print(result);
  num1=result;
  }



}