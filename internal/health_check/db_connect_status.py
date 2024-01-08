from db.models import Users


def get_users_count():
    return Users.select().count()


def db_connect_status():
    try:
        Users.select().count()
        return dict(
            task='db_connect_status',
            status="ok",
            msg=""
        )
    except Exception as e:
        return dict(
            task='db_connect_status',
            status="error",
            msg=str(e)
        )
