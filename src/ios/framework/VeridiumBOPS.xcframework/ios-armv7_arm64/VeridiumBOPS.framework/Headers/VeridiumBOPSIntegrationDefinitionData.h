//
//  VeridiumBOPSIntegrationDefinitionData.h
//  VeridiumBOPS
//
//  Created by razvan on 8/9/16.
//  Copyright © 2016 Veridium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "VeridiumBOPSLoginDefinitionData.h"
#import "VeridiumBOPSFieldDefinitionData.h"
#import <VeridiumCore/VeridiumAbstractData.h>
#import <VeridiumCore/IntegrationDefinition.h>

/*!
 Data class for holding a business integration definition data.
 
 This business integration definitions, once fetched from the server, are stored in the global user defaults storage and exposed via the BOPSAccountService [integrationDefinitions]([BOPSAccountService integrationDefinitions]) property
 
 __See also__
 
 - [BOPSAccountService integrationDefinitions]
 - [BOPSAccountService bopsRefreshIntegrations:onSuccess:onError:]
 */
@interface VeridiumBOPSIntegrationDefinitionData : IntegrationDefinition

/*!
 `true` if profiles can be registered for this business integration, `false` otherwise
 
 __this setting is specific to each business integration and is configured via the BOPS admin console__
 */
@property (readonly) BOOL canRegisterProfile;

/*!
 The logo image to display for the business integration
 
 A possible use would be to display this icon as a visual aid in a client app when displaying multiple profiles from multiple integration.
 */
@property (readonly, nullable) UIImage* logoImage;

/*!
 The BOPSLoginDefinitionData holding the login definition JSON object (defined in the BOPS admin console)
 */
@property (readonly, nullable) VeridiumBOPSLoginDefinitionData* loginDefinition;

@end
