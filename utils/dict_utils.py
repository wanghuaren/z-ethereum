class ObjDict(dict):
    """
    Makes a  dictionary behave like an object,with attribute-style access.
    """
    def __getattr__(self, name):
        try:
            return self[name]
        except Exception:
            return None
            
    def __setattr__(self,name,value):
        self[name]=value