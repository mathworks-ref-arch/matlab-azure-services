package com.mathworks.azure.sdk;

import java.util.Iterator;

import com.azure.core.credential.TokenRequestContext;
import com.azure.identity.DeviceCodeCredential;
import com.azure.identity.DeviceCodeCredentialBuilder;

import reactor.core.publisher.Flux;

 // Copyright 2022 The MathWorks, Inc.

public class DeviceCodeCredentialHelper {
    public static Iterator<Object> BuildAndAuthenticate(DeviceCodeCredentialBuilder builder, TokenRequestContext tokenRequestContext) {
        /* Create a new Flux which can emit two pieces of data:
         *   1. DeviceCodeInfo when the challengeConsumer is called.
         *   2. DeviceCodeCredential when the authentication completes.
        */
        return Flux.create(sink -> {
            /* Add a challengeConsumer which will emit the deviceCodeInfo */
            DeviceCodeCredential deviceCodeCredential = builder.challengeConsumer(deviceCodeInfo -> {
                sink.next(deviceCodeInfo);
            })
            /* Build the DeviceCodeCredential */
            .build();
            /* Call authenticate */
            deviceCodeCredential.authenticate(tokenRequestContext)
            /* Add a finally to complete() the Flux on authentication success but also on error (e.g. timeout).
               This will make any pending next() in MATLAB error out rather than hang indefinitely
               and will throw an error if you tried a third next(). */
            .doFinally((s) -> {
                sink.complete();
            })
            /*Actually perform the authentication by subscribing */
            .subscribe((authenticationRecord)-> {
                /* In this subscribe, which will be called when authentication 
                   succeeded, emit the now authenticated DeviceCodeCredential */
                sink.next(deviceCodeCredential);
            });
        })
        /* Do not return the Flux directly, return an iterator which is 
           easier to consume on the MATLAB end. You can simply call next() on this 
           to obtain the DeviceCodeInfo and then next() again to wait for authentication
           to complete and obtain the authenticated DeviceCodeCredential. */
        .toIterable().iterator();
    }
}
