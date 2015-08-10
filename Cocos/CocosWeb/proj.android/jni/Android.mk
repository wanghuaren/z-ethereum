LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := cocos2dcpp_shared

LOCAL_MODULE_FILENAME := libcocos2dcpp

define walk
    $(wildcard $(1)) $(foreach e, $(wildcard $(1)/*), $(call walk, $(e)))
endef

ALLFILES = $(call walk, $(LOCAL_PATH)/../../proj.win32/Classes)
FILE_LIST := hellocpp/main.cpp
FILE_LIST += $(filter %.cpp, $(ALLFILES))
LOCAL_SRC_FILES := $(FILE_LIST:$(LOCAL_PATH)/%=%)

LOCAL_C_INCLUDES := $(LOCAL_PATH)/../../proj.win32/Classes

LOCAL_STATIC_LIBRARIES := cocos2dx_static
LOCAL_STATIC_LIBRARIES += cocos2d_lua_static

include $(BUILD_SHARED_LIBRARY)

$(call import-module,scripting/lua-bindings/proj.android/prebuilt-mk)
$(call import-module,./prebuilt-mk)