#pragma once
template <class T>
class Singleton
{
private:
	static T* _instance;
public:
	static inline T* instance()
	{
		if (_instance == NULL)
			_instance = new T();
		return _instance;
	}

protected:
	Singleton(){
		
	};
	virtual ~Singleton(){};
	Singleton(const Singleton<T>&);
	Singleton<T>& operator= (const Singleton<T> &);
};
template <class T>
T* Singleton<T>::_instance;
