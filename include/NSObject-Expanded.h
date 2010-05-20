#if TARGET_IPHONE_SIMULATOR
enum {
	OBJC_ASSOCIATION_ASSIGN = 0,
	OBJC_ASSOCIATION_RETAIN_NONATOMIC = 1,
	OBJC_ASSOCIATION_COPY_NONATOMIC = 3,
	OBJC_ASSOCIATION_RETAIN = 01401,
	OBJC_ASSOCIATION_COPY = 01403
};
typedef uintptr_t objc_AssociationPolicy;

void objc_setAssociatedObject(id object, void *key, id value, objc_AssociationPolicy policy);
id objc_getAssociatedObject(id object, void *key);
void objc_removeAssociatedObjects(id object);
#endif

@interface NSObject (NSObject_Expanded)
- (void)associateValue:(id)value withKey:(void *)key; // Strong reference
- (void)weaklyAssociateValue:(id)value withKey:(void *)key;
- (id)associatedValueForKey:(void *)key;
@end
