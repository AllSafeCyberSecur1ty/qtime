; Copyright (c) Microsoft Corporation.
; Licensed under the MIT License.

; The __quantum__qis__* definitions should be automatically generated by QIR, depending on the specific target.
; However, for simulator targets we provide an optional simple bridge that covers commonly used intrinsics. 

;=======================================================================================================================
; QIR types
;
%Array = type opaque
%Callable = type opaque
%Qubit = type opaque
%Range = type { i64, i64, i64 }
%Result = type opaque
%String = type opaque
%Pauli = type i2

;=======================================================================================================================
; Native types
; NB: there is no overloading at IR level, so a call/invoke will be made even
; if the definition of the function mismatches the declaration of the arguments.
; It means we could declare here the bridge's C-functions using QIR types
; and avoid bitcasts. However, it seems prudent to be more explicit about
; what's going on and declare the true signatures, as generated by Clang.
;
%class.QUBIT = type opaque
%class.RESULT = type opaque
%struct.QirArray = type opaque
%struct.QirCallable = type opaque
%struct.QirRange = type { i64, i64, i64 }
%struct.QirString = type opaque
%PauliId = type i32

;===============================================================================
; quantum.qis math functions declarations
;

; LLVM intrinsics (https://llvm.org/docs/LangRef.html):
; TODO: consider calling these directly from the compiler-generated .ll code, rather than through the QIR. #632
declare double      @llvm.sqrt.f64(double %.val)
declare double      @llvm.log.f64(double %Val)
declare double      @llvm.sin.f64(double %Val)
declare double      @llvm.cos.f64(double %Val)

; Native implementations:
declare i1          @quantum__qis__isnan__body(double %d)
declare double      @quantum__qis__infinity__body()
declare i1          @quantum__qis__isinf__body(double %d)
declare double      @quantum__qis__arctan2__body(double %y, double %x)
declare double      @quantum__qis__sinh__body(double %theta)
declare double      @quantum__qis__cosh__body(double %theta)
declare double      @quantum__qis__arcsin__body(double %theta)
declare double      @quantum__qis__arccos__body(double %theta)
declare double      @quantum__qis__arctan__body(double %theta)
declare double      @quantum__qis__ieeeremainder__body(double %y, double %x)
declare i64         @quantum__qis__drawrandomint__body(i64 %min, i64 %max)
declare double      @quantum__qis__drawrandomdouble__body(double %min, double %max)

;===============================================================================
; quantum.qis conditional functions declarations
;
declare void @quantum__qis__applyifelseintrinsic__body(%class.RESULT*, %struct.QirCallable*, %struct.QirCallable*)
declare void @quantum__qis__applyconditionallyintrinsic__body(
  %struct.QirArray*, %struct.QirArray*, %struct.QirCallable*, %struct.QirCallable*)

;===============================================================================
; quantum.qis Assert Measurement functions/operations declarations
;
declare void @quantum__qis__assertmeasurementprobability__body(
    %struct.QirArray* %bases, %struct.QirArray* %qubits, %class.RESULT* %result, double %prob, %struct.QirString* %msg, double %tol)

;===============================================================================
; quantum.qis math functions implementation
;
; API for the user code:
define dllexport double @__quantum__qis__nan__body() {                ; Q#: function NAN() : Double       http://www.cplusplus.com/reference/cmath/nan-function/
  %result = call double @llvm.sqrt.f64(double -1.0)         ; sqrt(<negative>) -> NaN   
  ret double %result
}

define dllexport i1 @__quantum__qis__isnan__body(double %d) {         ; http://www.cplusplus.com/reference/cmath/isnan/
  %result = call i1 @quantum__qis__isnan__body(double %d)
  ret i1 %result
}

define dllexport double @__quantum__qis__infinity__body() {           ; https://en.cppreference.com/w/c/numeric/math/INFINITY
  %result = call double @quantum__qis__infinity__body()
  ret double %result
}

define dllexport i1 @__quantum__qis__isinf__body(double %d) {         ; https://en.cppreference.com/w/cpp/numeric/math/isinf
  %result = call i1 @quantum__qis__isinf__body(double %d)   
  ret i1 %result
}

define dllexport double @__quantum__qis__sqrt__body(double %d) {      ; https://en.cppreference.com/w/cpp/numeric/math/sqrt
  %result = call double @llvm.sqrt.f64(double %d)           
  ret double %result
}

define dllexport double @__quantum__qis__log__body(double %d) {       ; https://en.cppreference.com/w/cpp/numeric/math/log
  %result = call double @llvm.log.f64(double %d)           
  ret double %result
}

define dllexport i1 @__quantum__qis__isnegativeinfinity__body(double %d) {    ; Q#: function IsNegativeInfinity(d : Double) : Bool
                                                                    ; https://en.cppreference.com/w/cpp/numeric/math/log    https://llvm.org/docs/LangRef.html#llvm-log-intrinsic
  %negInf = call double @llvm.log.f64(double 0.0)                   ; ln(0) -> (-infinity)
  %result = fcmp oeq double %negInf, %d                             ; %result = (%negInf == %d)
  ret i1 %result
}

define dllexport double @__quantum__qis__arctan2__body(double %y, double %x) {  ; Q#: function ArcTan2 (y : Double, x : Double) : Double
                                                                    ; https://en.cppreference.com/w/cpp/numeric/math/atan2
  %result = call double @quantum__qis__arctan2__body(double %y, double %x)
  ret double %result
}

; function Sin (theta : Double) : Double
; https://docs.microsoft.com/qsharp/api/qsharp/microsoft.quantum.math.sin
define dllexport double @__quantum__qis__sin__body(double %theta) {       ; https://en.cppreference.com/w/cpp/numeric/math/sin
    %result = call double @llvm.sin.f64(double %theta)          ; https://llvm.org/docs/LangRef.html#llvm-sin-intrinsic
    ret double %result
}

; function Cos (theta : Double) : Double
; https://docs.microsoft.com/qsharp/api/qsharp/microsoft.quantum.math.cos
define dllexport double @__quantum__qis__cos__body(double %theta) {       ; https://en.cppreference.com/w/cpp/numeric/math/cos
    %result = call double @llvm.cos.f64(double %theta)          ; https://llvm.org/docs/LangRef.html#llvm-cos-intrinsic
    ret double %result
}

; function Tan (theta : Double) : Double
; https://docs.microsoft.com/qsharp/api/qsharp/microsoft.quantum.math.tan
define dllexport double @__quantum__qis__tan__body(double %theta) {       ; https://en.cppreference.com/w/cpp/numeric/math/tan
    %sin = call double @llvm.sin.f64(double %theta)
    %cos = call double @llvm.cos.f64(double %theta)
    %result = fdiv double %sin, %cos                            ; tg(x) = sin(x) / cos(x)
    ret double %result
}

; function Sinh (theta : Double) : Double
; https://docs.microsoft.com/qsharp/api/qsharp/microsoft.quantum.math.sinh
define dllexport double @__quantum__qis__sinh__body(double %theta) {      ; https://en.cppreference.com/w/cpp/numeric/math/sinh
    %result = call double @quantum__qis__sinh__body(double %theta)
    ret double %result
}

; function Cosh (theta : Double) : Double
; https://docs.microsoft.com/qsharp/api/qsharp/microsoft.quantum.math.cosh
define dllexport double @__quantum__qis__cosh__body(double %theta) {      ; https://en.cppreference.com/w/cpp/numeric/math/cosh
    %result = call double @quantum__qis__cosh__body(double %theta)
    ret double %result
}

; function Tanh (theta : Double) : Double
; https://docs.microsoft.com/qsharp/api/qsharp/microsoft.quantum.math.tanh
define dllexport double @__quantum__qis__tanh__body(double %theta) {      ; https://en.cppreference.com/w/cpp/numeric/math/tanh
    %sin = call double @__quantum__qis__sinh__body(double %theta)
    %cos = call double @__quantum__qis__cosh__body(double %theta)
    %result = fdiv double %sin, %cos                            ; tanh(x) = sinh(x) / cosh(x)
    ret double %result
}

; function ArcSin (theta : Double) : Double
; https://docs.microsoft.com/qsharp/api/qsharp/microsoft.quantum.math.arcsin
define dllexport double @__quantum__qis__arcsin__body(double %theta) {    ; https://en.cppreference.com/w/cpp/numeric/math/asin
    %result = call double @quantum__qis__arcsin__body(double %theta)
    ret double %result
}

; function ArcCos (theta : Double) : Double
; https://docs.microsoft.com/qsharp/api/qsharp/microsoft.quantum.math.arccos
define dllexport double @__quantum__qis__arccos__body(double %theta) {    ; https://en.cppreference.com/w/cpp/numeric/math/acos
    %result = call double @quantum__qis__arccos__body(double %theta)
    ret double %result
}

; function ArcTan (theta : Double) : Double
; https://docs.microsoft.com/qsharp/api/qsharp/microsoft.quantum.math.arctan
define dllexport double @__quantum__qis__arctan__body(double %theta) {    ; https://en.cppreference.com/w/cpp/numeric/math/atan
    %result = call double @quantum__qis__arctan__body(double %theta)
    ret double %result
}


; function IEEERemainder(x : Double, y : Double) : Double
define dllexport double @__quantum__qis__ieeeremainder__body(double %x, double %y) {
  %result = call double @quantum__qis__ieeeremainder__body(double %x, double %y)
  ret double %result
}


; operation DrawRandomInt (min : Int, max : Int) : Int      
; https://docs.microsoft.com/qsharp/api/qsharp/microsoft.quantum.random.drawrandomint
define dllexport i64 @__quantum__qis__drawrandomint__body(i64 %min, i64 %max) {  
  %result = call i64 @quantum__qis__drawrandomint__body(i64 %min, i64 %max)
  ret i64 %result
}

; operation DrawRandomDouble (min : Double, max : Double) : Double
; https://docs.microsoft.com/qsharp/api/qsharp/microsoft.quantum.random.drawrandomdouble
define dllexport double @__quantum__qis__drawrandomdouble__body(double %min, double %max) {
  %result = call double @quantum__qis__drawrandomdouble__body(double %min, double %max)
  ret double %result
}



;===============================================================================
; quantum.qis conditional functions/operations implementation
;
define dllexport void @__quantum__qis__applyifelseintrinsic__body(
  %Result* %.r, %Callable* %.clb_on_zero, %Callable* %.clb_on_one) {

  %r = bitcast %Result* %.r to %class.RESULT*
  %clb_on_zero = bitcast %Callable* %.clb_on_zero to %struct.QirCallable*
  %clb_on_one = bitcast %Callable* %.clb_on_one to %struct.QirCallable*
  call void @quantum__qis__applyifelseintrinsic__body(
    %class.RESULT* %r, %struct.QirCallable* %clb_on_zero, %struct.QirCallable* %clb_on_one)
  ret void
}

define dllexport void @__quantum__qis__applyconditionallyintrinsic__body(
  %Array* %.rs1, %Array* %.rs2, %Callable* %.clb_on_equal, %Callable* %.clb_on_different) {

  %rs1 = bitcast %Array* %.rs1 to %struct.QirArray*
  %rs2 = bitcast %Array* %.rs2 to %struct.QirArray*
  %clb_on_equal = bitcast %Callable* %.clb_on_equal to %struct.QirCallable*
  %clb_on_different = bitcast %Callable* %.clb_on_different to %struct.QirCallable*
  call void @quantum__qis__applyconditionallyintrinsic__body(
    %struct.QirArray* %rs1, %struct.QirArray* %rs2,
    %struct.QirCallable* %clb_on_equal, %struct.QirCallable* %clb_on_different)
  ret void
}

;===============================================================================
; quantum.qis AssertMeasurementProbability functions/operations implementation
;
define dllexport void @__quantum__qis__assertmeasurementprobability__body(
  %Array* %.bases, %Array* %.qubits, %Result* %.result, double %prob, %String* %.msg, double %tol) {
  
  %bases  = bitcast %Array*  %.bases  to %struct.QirArray*
  %qubits = bitcast %Array*  %.qubits to %struct.QirArray*
  %result = bitcast %Result* %.result to %class.RESULT*
  %msg    = bitcast %String* %.msg    to %struct.QirString*

  call void @quantum__qis__assertmeasurementprobability__body(
    %struct.QirArray* %bases, %struct.QirArray* %qubits, %class.RESULT* %result, double %prob, %struct.QirString* %msg, double %tol)

  ret void
}

define dllexport void @__quantum__qis__assertmeasurementprobability__adj(
  %Array* %.bases, %Array* %.qubits, %Result* %.result, double %prob, %String* %.msg, double %tol) {
  ; Empty.
  ret void
}

define dllexport void @__quantum__qis__assertmeasurementprobability__ctl(
  %Array* %.ctrlQubits,
  %Array* %.bases, %Array* %.qubits, %Result* %.result, double %prob, %String* %.msg, double %tol) {
  ; Empty.
  ret void
}

define dllexport void @__quantum__qis__assertmeasurementprobability__ctladj(
  %Array* %.ctrlQubits,
  %Array* %.bases, %Array* %.qubits, %Result* %.result, double %prob, %String* %.msg, double %tol) {
  ; Empty.
  ret void
}