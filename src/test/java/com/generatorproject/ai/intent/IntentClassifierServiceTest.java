package com.generatorproject.ai.intent;

import org.junit.Assert;
import org.junit.Test;

public class IntentClassifierServiceTest {
    private final IntentClassifierService service = new IntentClassifierService();

    @Test
    public void classifiesOwnedDeviceLookupFromSerialQuery() {
        ParsedIntent parsed = service.classify("Tìm thiết bị của tôi theo serial ABC123");

        Assert.assertEquals(ChatIntent.OWNED_DEVICE_LOOKUP, parsed.getIntent());
        Assert.assertEquals("ABC123", parsed.getEntity("serial"));
    }

    @Test
    public void classifiesMaintenanceSupport() {
        ParsedIntent parsed = service.classify("Máy này bảo trì gần nhất khi nào");

        Assert.assertEquals(ChatIntent.MAINTENANCE_SUPPORT, parsed.getIntent());
    }

    @Test
    public void classifiesTechnicalDocumentSupport() {
        ParsedIntent parsed = service.classify("Low oil pressure thì kiểm tra gì trước");

        Assert.assertEquals(ChatIntent.TECHNICAL_DOCUMENT_SUPPORT, parsed.getIntent());
    }

    @Test
    public void classifiesPublicModelLookup() {
        ParsedIntent parsed = service.classify("Tìm model Denyo DCA-150");

        Assert.assertEquals(ChatIntent.PUBLIC_MODEL_LOOKUP, parsed.getIntent());
        Assert.assertNotNull(parsed.getEntity("model"));
    }
}
