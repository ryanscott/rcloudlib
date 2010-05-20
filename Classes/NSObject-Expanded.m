#import "NSObject-Expanded.h"
#import <objc/runtime.h>
#import <dlfcn.h>

#if TARGET_IPHONE_SIMULATOR
void objc_setAssociatedObject(id object, void *key, id value, objc_AssociationPolicy policy) {
	((void (*)(id, void *, id, objc_AssociationPolicy))
	 dlsym(RTLD_NEXT, "objc_setAssociatedObject")) (object, key, value, policy);
}
id objc_getAssociatedObject(id object, void *key) {
	return ((id (*)(id, void *))
					dlsym(RTLD_NEXT, "objc_getAssociatedObject"))(object, key);
}
void objc_removeAssociatedObjects(id object) {
	((void (*)(id))
	 dlsym(RTLD_NEXT, "objc_removeAssociatedObjects"))(object);
}
#endif

@implementation NSObject (NSObject_Expanded)

- (void)associateValue:(id)value withKey:(void *)key
{
	objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN);
}

- (void)weaklyAssociateValue:(id)value withKey:(void *)key
{
	objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_ASSIGN);
}

- (id)associatedValueForKey:(void *)key
{
	return objc_getAssociatedObject(self, key);
}

@end
