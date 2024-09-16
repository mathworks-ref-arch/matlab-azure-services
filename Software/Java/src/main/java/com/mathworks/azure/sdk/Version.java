package com.mathworks.azure.sdk;
import java.lang.reflect.Method;
import java.lang.reflect.InvocationTargetException;
/**
 * Sanity Check!
 *
 */

 // Copyright 2018 The MathWorks, Inc.

public class Version
{
    public static void main(String[] argv)
    {
        System.out.println( "Class Loaded" );
    }

    public static String longToString(long x)
    {
        return String.valueOf(x);
    }

    // No arguments are supported
    public static String invokeNamedMethodToString(Object obj, String methodName)
    {
        java.lang.reflect.Method method;
        try {
            method = obj.getClass().getMethod(methodName);
            try {
                return String.valueOf(method.invoke(obj));
            }
            catch (IllegalArgumentException e) {
                System.err.println("Exception: IllegalArgumentException");
            }
            catch (IllegalAccessException e) {
                System.err.println("Exception: IllegalAccessException");
            }
            catch (InvocationTargetException e) {
                System.err.println("Exception: InvocationTargetException");
            }
        }
        catch (SecurityException e) {
            System.err.println("Exception: SecurityException");
        }
        catch (NoSuchMethodException e) {
            System.err.printf("Exception: NoSuchMethodException: %s\n", methodName);
        }
    
        System.err.println( "Unexpected state, returning \"\"");
        return "";
    }
}
