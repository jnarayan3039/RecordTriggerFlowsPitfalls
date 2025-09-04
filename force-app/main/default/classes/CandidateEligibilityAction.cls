public with sharing class CandidateEligibilityAction {
    public class Request {
        @InvocableVariable(required=true)
        public Id candidateId;
    }
    public class Response {
        @InvocableVariable
        public Boolean isEligible;
        @InvocableVariable
        public String reason; // optional for logging
    }

    @InvocableMethod(label='Check Candidate Eligibility')
    public static List<Response> check(List<Request> reqs) {
        // Collect candidate Ids from requests
        Set<Id> candIds = new Set<Id>();
        for (Request r : reqs) {
            if (r.candidateId != null) {
                candIds.add(r.candidateId);
            }
        }

        // Query candidates
        Map<Id, Candidate__c> cs = new Map<Id, Candidate__c>(
            [SELECT Id, Years_Of_Experience__c, Email__c,
                    Certifications__c, Primary_Certification__c
             FROM Candidate__c
             WHERE Id IN :candIds]
        );

        List<Response> out = new List<Response>();
        for (Request r : reqs) {
            Candidate__c c = cs.get(r.candidateId);
            Response res = new Response();
			System.debug(c.Years_Of_Experience__c+' '+ c.Primary_Certification__c+' '+ c.Email__c);
            if (c != null) {
                Boolean ok = (c.Years_Of_Experience__c >= 2) &&
                             (c.Primary_Certification__c  == 'Salesforce Administrator');
                             //Pattern.matches('[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}', c.Email__c);

                res.isEligible = ok;
                res.reason = ok ? 'OK' : 'Missing requirements';
            } else {
                res.isEligible = false;
                res.reason = 'Candidate not found';
            }
            out.add(res);
        }
        return out;
    }
}