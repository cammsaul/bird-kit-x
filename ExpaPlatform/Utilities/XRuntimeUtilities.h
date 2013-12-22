//
//  XRuntimeUtilities.h
//  ExpaPlatform
//
//  Created by Cam Saul on 12/21/13.
//  Copyright (c) 2013 Expa, LLC. All rights reserved.
//

/// The type of block you should return when using swizzle_with_block.
typedef void(^swizzle_with_block_t)(id _self, ...);

/// Easy method to swizzle a method with a block. Returns a pointer to the original function as well, if
/// you would like to call that from the swizzled block. Example:
/// #\code
///	swizzle_with_block(NSLayoutConstraint.class, sel_registerName("_addToEngine:integralizationAdjustment:mutuallyExclusiveConstraints:"), ^id(SEL sel, void(*orig_fptr)(id, SEL, ...)) {
///		return ^(UIView *_self, id engine, id integralizationAdjustment, id mutuallyExclusiveConstraints) {
///			@try {
///				orig_fptr(_self, sel, engine, integralizationAdjustment, mutuallyExclusiveConstraints);
///			} @catch (NSException *e) {
///				XLog(self, LogFlagError, @"Caught AutoLayout exception: %@", e);
///			}
///		};
///	});
/// #\endcode
void swizzle_with_block(Class cls, SEL sel, swizzle_with_block_t(^block)(SEL sel, void(*orig_fptr)(id _self, SEL _sel, ...)));

/// Easy method to add a method to a class at runtime with a block. Method signature is inferred automatically based on block's type.
void add_method_with_block(Class cls, const char *name, id _block);

/// Debugger utility method that dumps all methods and signatures instances of a class respond to.
void debug_class_dump_methods(const id cls);

#define _ASSOC_PROP(TYPE, GETTER, SETTER, OBJC_ASSOCIATION_POLICY, PLUS_OR_MINUS) \
	static const char GETTER##Key = '\0'; \
	PLUS_OR_MINUS (TYPE)GETTER { \
		return objc_getAssociatedObject(self, &GETTER##Key); \
	} \
	PLUS_OR_MINUS (void)SETTER:(TYPE)obj { \
		objc_setAssociatedObject(self, &GETTER##Key, obj, OBJC_ASSOCIATION_POLICY); \
	}

/// Helper macro to add a strongly retained associated property (with getter and setter) to an object. Requires you to #import <objc/runtime.h>
#define ASSOC_PROP_STRONG(TYPE, GETTER, SETTER) _ASSOC_PROP(TYPE, GETTER, SETTER, OBJC_ASSOCIATION_RETAIN_NONATOMIC, -)

/// Helper macro to add a copied associated property (with getter and setter) to an object. Requires you to #import <objc/runtime.h>
#define ASSOC_PROP_COPY(TYPE, GETTER, SETTER) _ASSOC_PROP(TYPE, GETTER, SETTER, OBJC_ASSOCIATION_COPY_NONATOMIC, -)

/// Helper macro to add a strongly retained associated property (with getter and setter) to a class. Requires you to #import <objc/runtime.h>
#define ASSOC_CLASS_PROP_STRONG(TYPE, GETTER, SETTER) _ASSOC_PROP(TYPE, GETTER, SETTER, OBJC_ASSOCIATION_RETAIN_NONATOMIC, +)

/// Helper macro to add a copied associated property (with getter and setter) to a class. Requires you to #import <objc/runtime.h>
#define ASSOC_CLASS_PROP_COPY(TYPE, GETTER, SETTER) _ASSOC_PROP(TYPE, GETTER, SETTER, OBJC_ASSOCIATION_COPY_NONATOMIC, +)