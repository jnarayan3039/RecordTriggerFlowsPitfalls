public with sharing class BrokenAction {
    public class Req { @InvocableVariable public Id candidateId; }
    public class Res { @InvocableVariable public Boolean ok; }

    /*@InvocableMethod(label='Broken – returns only 1 result')
    public static List<Res> doIt(List<Req> reqs) {
        // BUG: always return exactly 1 result, regardless of request count
        Res r = new Res(); r.ok = true;
        return new List<Res>{ r }; // <-- Requests: N ; Results: 1  (Mismatch!)
    }*/
    
    @InvocableMethod(label='Broken – returns only 1 result')
    public static List<Res> doIt(List<Req> reqs) {
        List<Res> resList = new List<Res>();
        // BUG: always return exactly 1 result, regardless of request count
        for(Req req: reqs){
           Res r = new Res(); r.ok = true;
           resList.add(r); 
        }
        
        return resList; // <-- Requests: N ; Results: 1  (Mismatch!)
    }
}