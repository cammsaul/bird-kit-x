//
//  XGlobalMacros.h
//  ExpaPlatform
//
//  Created by Cameron Saul on 10/22/13.
//  Copyright (c) 2013 Expa, LLC. All rights reserved.
//

#define PROP			@property (nonatomic, readwrite)
#define PROP_RO			@property (nonatomic, readonly)
#define PROP_STRONG		@property (nonatomic, strong, readwrite)
#define PROP_STRONG_RO	@property (nonatomic, strong, readonly)
#define PROP_COPY		@property (nonatomic, copy, readwrite)
#define PROP_COPY_RO	@property (nonatomic, copy, readonly)
#define PROP_WEAK		@property (nonatomic, weak, readwrite)
#define PROP_WEAK_RO	@property (nonatomic, weak, readonly)
#define PROP_DELEGATE(PROTOCOL) PROP_WEAK id<PROTOCOL> delegate
#define PROP_DATASOURCE(PROTOCOL) PROP_WEAK id<PROTOCOL> datasource
#define PROP_DELEGATE_RO(PROTOCOL) PROP_WEAK_RO id<PROTOCOL> delegate
#define PROP_DATASOURCE_RO(PROTOCOL) PROP_WEAK_RO id<PROTOCOL> datasource