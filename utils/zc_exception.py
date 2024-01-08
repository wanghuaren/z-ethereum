class ZCException(Exception):
    def __init__(self, error_message, error_code=1000):
        super().__init__((error_code, error_message))
        self.error_message = error_message
        self.error_code = error_code

    def __str__(self):
        return {"error_code": str(self.error_code), "error_message": repr(self.error_message)}

    @property
    def message(self):
        return self.error_message

    @property
    def code(self):
        return self.error_code
