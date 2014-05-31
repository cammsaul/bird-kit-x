//
//  XRuntimeUtilities.m
//  ExpaPlatform
//
//  Created by Cam Saul on 12/21/13.
//  Copyright (c) 2013 Expa, LLC. All rights reserved.
//

#import "XRuntimeUtilities.h"
#import <objc/runtime.h>

void swizzle_method_with_block(Method orig_method, Class cls, SEL sel, swizzle_with_block_t(^block)(SEL sel, void(*orig_fptr)(id _self, SEL _sel, ...))) {
	IMP orig_imp = method_getImplementation(orig_method);
	
	id _swzz_blck = block(sel, (void(*)(id _self, SEL _sel, ...))orig_imp);
	
	// store the block as an associated object so it gets copied onto heap
	const char *assoc_key = sel_getName(sel);
	objc_setAssociatedObject(cls, assoc_key, _swzz_blck, OBJC_ASSOCIATION_COPY_NONATOMIC);
	id swzz_blck = objc_getAssociatedObject(cls, assoc_key);
	
	IMP swizz_imp = imp_implementationWithBlock(swzz_blck);
	class_replaceMethod(cls, sel, swizz_imp, method_getTypeEncoding(orig_method));
}

void swizzle_with_block(Class cls, SEL sel, swizzle_with_block_t(^block)(SEL sel, void(*orig_fptr)(id _self, SEL _sel, ...))) {
	Method orig_method = class_getInstanceMethod(cls, sel);
	swizzle_method_with_block(orig_method, cls, sel, block);
}

void swizzle_class_method_with_block(Class _cls, SEL sel, swizzle_with_block_t(^block)(SEL sel, void(*orig_fptr)(id _self, SEL _sel, ...))) {
	Class cls = object_getClass(_cls);
	
	Method orig_method = class_getClassMethod(cls, sel);
	swizzle_method_with_block(orig_method, cls, sel, block);
}

void swizzle_swap_class_methods(Class _cls, SEL orig_sel, SEL new_sel) {
	Class cls = object_getClass(_cls);
	Method orig_m = class_getClassMethod(cls, orig_sel);
	
	Method new_m = class_getClassMethod(cls, new_sel);
	IMP new_imp = method_getImplementation(new_m);
	
	IMP orig_imp = class_replaceMethod(cls, orig_sel, new_imp, method_getTypeEncoding(orig_m));
	if (orig_imp) class_replaceMethod(cls, new_sel, orig_imp, method_getTypeEncoding(new_m));
}

void swizzle_swap_methods(Class cls, SEL orig_sel, SEL new_sel) {
	Method orig_m = class_getInstanceMethod(cls, orig_sel);
	
	Method new_m = class_getInstanceMethod(cls, new_sel);
	IMP new_imp = method_getImplementation(new_m);
	
	IMP orig_imp = class_replaceMethod(cls, orig_sel, new_imp, method_getTypeEncoding(orig_m));
	class_replaceMethod(cls, new_sel, orig_imp, method_getTypeEncoding(new_m));
}


void add_method_with_block(Class cls, const char *name, id _block){
	struct _block_descriptor_t {
		unsigned long reserved;
		unsigned long size;
		void *rest[1];
	};
	
	struct _block_t {
		void *isa;
		int flags;
		int reserved;
		void *invoke;
		struct _block_descriptor_t *descriptor;
	};
	
	static const int flag_copy_dispose = 1 << 25;
    static const int flag_has_signature = 1 << 30;
	
	SEL sel = sel_registerName(name);
	
	const char *assoc_key = sel_getName(sel);
	objc_setAssociatedObject(cls, assoc_key, _block, OBJC_ASSOCIATION_COPY_NONATOMIC);
	id block = objc_getAssociatedObject(cls, assoc_key);
	struct _block_t *block_struct = (__bridge struct _block_t *)block;
	
	if (!(block_struct->flags & flag_has_signature)) {
		@throw [[NSException alloc] initWithName:[NSString stringWithFormat:@"add_method_with_block(%@, %s, ...) failed", NSStringFromClass(cls), name] reason:@"Block does not have a method signature." userInfo:nil];
	}
	
	const int index = (block_struct->flags & flag_copy_dispose) ? 2 : 0;
    const char *types = (char *)block_struct->descriptor->rest[index];
	
	IMP imp = imp_implementationWithBlock(block);
	
	class_addMethod(cls, sel, imp, types);
}


void debug_class_dump_methods(const id cls) {
	unsigned numMethods;
	const Method * const methods = class_copyMethodList(cls, &numMethods);
	for (int i = 0; i < numMethods; i++) {
		const Method m = methods[i];
		printf("%s %s\n", sel_getName(method_getName(m)), method_getTypeEncoding(m));
	}
	
	Class superclass = [cls superclass];
	const char *name = class_getName(superclass);
	printf("\nsuperclass: %s\n", name);
	if (!strcmp(name, "NSObject")) {
		debug_class_dump_methods(superclass);
	} else {
		printf("[END]\n\n\n");
	}
}