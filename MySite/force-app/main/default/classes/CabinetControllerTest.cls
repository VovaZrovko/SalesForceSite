@isTest
public class CabinetControllerTest {
    @isTest
    public static void PostSocialTest(){
        Test.startTest();
        CabinetController c = new CabinetController('s');
        PageReference page = c.PostSocial();
        Test.stopTest();

        System.assertEquals(page.getParameters().get('state'), '12345567dggd');
    }
    @isTest
    public static void PositiveMakePostTest(){
        String userId = '123';
        String token = '222';
        Test.setMock(HttpCalloutMock.class, new PostHttpCalloutMock(200,'',null)); 

        Test.startTest();
        CabinetController c = new CabinetController('s');
        c.MakePost(token,userId);
        Test.stopTest();

        List<Apexpages.Message> msgs = ApexPages.getMessages();
        System.assert(msgs.size() == 1);
        System.assert(msgs[0].getDetail().contains('Posted'));
    }
    @isTest
    public static void NegativeMakePostTest(){
        String userId = '123';
        String token = '222';
        Test.setMock(HttpCalloutMock.class, new PostHttpCalloutMock(400,'',null)); 

        Test.startTest();
        CabinetController c = new CabinetController('s');
        c.MakePost(token,userId);
        Test.stopTest();

        List<Apexpages.Message> msgs = ApexPages.getMessages();
        System.assert(msgs.size() == 1);
        System.assert(msgs[0].getDetail().contains('problem with post Status'));
    }
    @isTest
    public static void PositiveGetPersonalIdTest(){
        String token = '222';
        Test.setMock(HttpCalloutMock.class, new PostHttpCalloutMock(200,'{"id": "456"}',null));

        Test.startTest();
        CabinetController c = new CabinetController('s');
        String userId = c.getPersonalId(token);
        Test.stopTest();

        System.assertEquals(userId,'456');
    }
    @isTest
    public static void NegativeGetPersonalIdTest(){
        String token = '222';
        Test.setMock(HttpCalloutMock.class, new PostHttpCalloutMock(400,'',null));

        Test.startTest();
        CabinetController c = new CabinetController('s');
        String userId = c.getPersonalId(token);
        Test.stopTest();

        System.assertEquals(userId,'');
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        System.assert(msgs.size() == 1);
        System.assert(msgs[0].getDetail().contains('problem with Id'));
    }
    @isTest
    public static void PositiveSendMessageTest(){
        Test.setMock(HttpCalloutMock.class, new PostHttpCalloutMock(200,'{"access_token": "456"}',null));

        Test.startTest();
        CabinetController c = new CabinetController('s');
        String token = c.SendMessage();
        Test.stopTest();

        System.assertEquals(token,'456');
    }
    @isTest
    public static void NegativeSendMessageTest(){
        Test.setMock(HttpCalloutMock.class, new PostHttpCalloutMock(400,'',null));

        Test.startTest();
        CabinetController c = new CabinetController('s');
        String token = c.SendMessage();
        Test.stopTest();

        System.assertEquals(token,'');
        List<Apexpages.Message> msgs = ApexPages.getMessages();
        System.assert(msgs.size() == 1);
        System.assert(msgs[0].getDetail().contains('problem with token'));
    }
}