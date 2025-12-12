@JsonAccess(serializable='always' deserializable='always')
global class WebhookResponse {
    global Boolean success;
    global String recordType;
    global Id recordId;
    global String message;
}