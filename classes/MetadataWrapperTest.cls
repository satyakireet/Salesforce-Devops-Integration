@isTest
public class MetadataWrapperTest {

    @isTest
    public static void testMetadataWrapperConstructorWithTwoParameter(){
        MetadataWrapper mw = new MetadataWrapper('Metadata Name', 'Metadata Type');
        System.assertEquals('Metadata Name', mw.name);
        System.assertEquals('Metadata Type', mw.type);
    }
    
    @isTest
    public static void testMetadataWrapperConstructorWithThreeParameter(){
        MetadataWrapper mw = new MetadataWrapper('Metadata Name', 'Metadata Type',Date.today());
        System.assertEquals('Metadata Name', mw.name);
        System.assertEquals('Metadata Type', mw.type);
        System.assertEquals(Date.today(), mw.lastModifiedDate);
    }
    
    @isTest
    public static void testMetadataWrapperConstructorWithNoParameter(){
        MetadataWrapper mw = new MetadataWrapper();
        System.assertEquals(null, mw.name);
        System.assertEquals(null, mw.type);
    }
}