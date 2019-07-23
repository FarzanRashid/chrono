%{

/* Includes the header in the wrapper code */
#include "chrono/core/ChMatrix.h"
#include <Eigen/Core>
#include <Eigen/Dense>

#include "Eigen/src/Core/Matrix.h"
#include "Eigen/src/Core/util/Macros.h"

using namespace chrono;

%}

#define EIGEN_DENSE_PUBLIC_INTERFACE(Derived) \
#define EIGEN_STRONG_INLINE __forceinline
#define EIGEN_DEVICE_FUNC

//%ignore EIGEN_DEVICE_FUNC;
//%ignore EIGEN_STRONG_INLINE;

/* Parse the header file to generate wrappers */
//%include "Eigen/src/Core/Matrix.h"    


//%template(ChMatrixNMD) chrono::ChMatrixNM<double>;  
//%template(ChMatrixDynamicD) chrono::ChMatrixDynamic<double>;

template <typename Real = double>
class chrono::ChMatrixDynamic : public Eigen::Matrix<Real, Eigen::Dynamic, Eigen::Dynamic, Eigen::RowMajor> {
	public:
		ChMatrixDynamic() : Eigen::Matrix<Real, Eigen::Dynamic, Eigen::Dynamic, Eigen::RowMajor>() {}
		ChMatrixDynamic(int r, int c) {
			Eigen::Matrix<Real, Eigen::Dynamic, Eigen::Dynamic, Eigen::RowMajor>();
			this->resize(r,c);
			}
		};

%template(ChMatrixDynamicD) chrono::ChMatrixDynamic<double>;

template <typename T = double>
class chrono::ChVectorDynamic : public Eigen::Matrix<T, Eigen::Dynamic, 1, Eigen::ColMajor> {
	public:
		ChVectorDynamic() : Eigen::Matrix<T, Eigen::Dynamic, 1, Eigen::ColMajor>() {}
		ChVectorDynamic(int r) {
			Eigen::Matrix<T, Eigen::Dynamic, 1, Eigen::ColMajor>();
			this->resize(r);
			}
		};

%template(ChVectorDynamicD) chrono::ChVectorDynamic<double>;

%extend chrono::ChVectorDynamic<double>{
		public:
			double __getitem__(int i) {
				return (*$self)(i,1);
				}

			const int Size() {
				const int r = $self->rows();
				return r;
				}

		};

%extend chrono::ChMatrixDynamic<double>{
		public:
					// these functions are also argument-templated, so we need to specify the types
					// ***SWIG template mechanism does not work here for operator() ***
			//%template(operator+) operator+<double>;
			//%template(operator-) operator-<double>;
			//%template(operator*) operator*<double>;
			/*ChMatrixDynamic<double> operator+(const ChMatrix<double>& matbis) 
						{ return $self->operator+(matbis);};
			ChMatrixDynamic<double> operator-(const ChMatrix<double>& matbis) 
						{ return $self->operator-(matbis);};
			ChMatrixDynamic<double> operator*(const ChMatrix<double>& matbis) 
						{ return $self->operator*(matbis);};*/

			double getitem(int i, int j) {
				return (*$self)(i, j);
				}
			const int GetRows() {
				const int r = $self->rows();
				return r;
				}
			const int GetColumns() {
				const int c = $self->cols();
				return c;
				}
		};

/*
%extend chrono::ChMatrix<double>{
		public:
					// Add function to support python 'print(...)'
			char *__str__() 
						{
							static char temp[2000];
							sprintf(temp, "Matrix, size= %d x %d \n", $self->GetRows(), $self->GetColumns());
							for (int row=0; row < ChMin(6,$self->GetRows()); row++)
							{
								for (int col=0; col < ChMin(6,$self->GetColumns()); col++)
								{
									sprintf(temp, "%s%g  ", temp, $self->GetElement(row,col));
								}
								if ($self->GetColumns() >6) sprintf(temp,"%s ...", temp);
								sprintf(temp,"%s\n", temp);
							}
							if ($self->GetRows() >6) sprintf(temp,"%s ...\n", temp);
							return &temp[0];
						}
					// these functions are also argument-templated, so we need to specify the types
			%template(CopyFromMatrix) CopyFromMatrix<double>;
			%template(CopyFromMatrixT) CopyFromMatrixT<double>;
			%template(MatrAdd) MatrAdd<double,double>;
			%template(MatrSub) MatrSub<double,double>;
			%template(MatrInc) MatrInc<double>;
			%template(MatrDec) MatrDec<double>;
			%template(MatrMultiply) MatrMultiply<double,double>;
			%template(MatrTMultiply) MatrTMultiply<double,double>;
			%template(MatrMultiplyT) MatrMultiplyT<double,double>;
			//%template(MatrDot) MatrDot<double,double>; // static fn, does not work here..
			%template(Matr34_x_Quat) Matr34_x_Quat<double>;
			%template(Matr34T_x_Vect) Matr34T_x_Vect<double>;
			%template(Matr44_x_Quat) Matr44_x_Quat<double>;
			%template(PasteMatrix) PasteMatrix<double>;
			%template(PasteSumMatrix) PasteSumMatrix<double>;
			%template(PasteTranspMatrix) PasteTranspMatrix<double>;
			%template(PasteSumTranspMatrix) PasteSumTranspMatrix<double>;
			%template(PasteClippedMatrix) PasteClippedMatrix<double>;
			%template(PasteSumClippedMatrix) PasteSumClippedMatrix<double>;
			%template(PasteVector) PasteVector<double>;
			%template(PasteSumVector) PasteSumVector<double>;
			%template(PasteSubVector) PasteSubVector<double>;
			%template(PasteQuaternion) PasteQuaternion<double>;
			%template(PasteSumQuaternion) PasteSumQuaternion<double>;
			%template(PasteCoordsys) PasteCoordsys<double>;
			%template(Set_Xq_matrix) Set_Xq_matrix<double>;
		};


//
// ADD PYTHON CODE
//

%pythoncode %{

def __matr_setitem(self,index,vals):
    row = index[0];
    col = index[1];
    if row>=self.GetRows() or row <0:
        raise NameError('Bad row. Setting value at [{0},{1}] in a {2}x{3} matrix'.format(row,col,self.GetRows(),self.GetColumns()))
    if col>=self.GetColumns() or col <0:
        raise NameError('Bad column. Setting value at [{0},{1}] in a {2}x{3} matrix'.format(row,col,self.GetRows(),self.GetColumns()))
    self.SetElement(index[0],index[1],vals)

def __matr_getitem(self,index):
    row = index[0];
    col = index[1];
    if row>=self.GetRows() or row <0:
        raise NameError('Bad row. Getting value at [{0},{1}] in a {2}x{3} matrix'.format(row,col,self.GetRows(),self.GetColumns()))
    if col>=self.GetColumns() or col <0:
        raise NameError('Bad column. Getting value at [{0},{1}] in a {2}x{3} matrix'.format(row,col,self.GetRows(),self.GetColumns()))
    return self.GetElement(index[0],index[1])

setattr(ChMatrixD, "__getitem__", __matr_getitem)
setattr(ChMatrixD, "__setitem__", __matr_setitem)

%}
*/

%ignore chrono::ChMatrixDynamic;
%include "../chrono/core/ChMatrix.h"