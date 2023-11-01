dtmc

const int t;

module monitor
    finished : bool init false;
    [finish1] true -> (finished'=true);
endmodule

module client1
    state1 : [0..1] init 0; // State of the job (inactive/active)
    task1  : [0..5] init 0; // Length of the job
    tickets1 : [1..16] init 1;
    
    // Create a new job - length chose non-deterministically
    [create1] state1=0 -> (state1'=1) & (task1'=1) & (tickets1'=16);
    [create1] state1=0 -> (state1'=1) & (task1'=2) & (tickets1'=8);
    [create1] state1=0 -> (state1'=1) & (task1'=3) & (tickets1'=4);
    [create1] state1=0 -> (state1'=1) & (task1'=4) & (tickets1'=2);
    [create1] state1=0 -> (state1'=1) & (task1'=5) & (tickets1'=1);

    // Serve the job
    [serve1] state1=1 & task1>0 -> (task1'=task1-1) & (tickets1'=tickets1*2);

    // Complete the job
    [finish1] state1=1 & task1=0 -> (state1'=0);

endmodule

module client2 = client1 [state1=state2,
                            task1=task2,
                            create1=create2,
                            serve1=serve2,
                            finish1=finish2,
                            tickets1=tickets2 ]
endmodule

module client3 = client1 [state1=state3,
                            task1=task3,
                            create1=create3,
                            serve1=serve3,
                            finish1=finish3,
                            tickets1=tickets3 ]
endmodule


module scheduler
    job1 : bool init false; // Is there a job from client1?
    job2 : bool init false; // Is there a job from client2?
    job3 : bool init false; // Is there a job from client3?

    ticket : [1..3] init 1;
    
    // Record that there is a waiting job
    [create1] job1=false -> (job1'=true);
    [create2] job2=false -> (job2'=true);
    [create3] job3=false -> (job3'=true);





    // Serve the job with current ticket and draw new ticket with variable probabilities
    [serve1] job1=true & ticket=1 -> tickets1/(tickets1 + tickets2 + tickets3):(ticket'=1) + tickets2/(tickets1 + tickets2 + tickets3):(ticket'=2) + tickets3/(tickets1 + tickets2 + tickets3):(ticket'=3);
    [serve2] job2=true & ticket=2 -> tickets1/(tickets1 + tickets2 + tickets3):(ticket'=1) + tickets2/(tickets1 + tickets2 + tickets3):(ticket'=2) + tickets3/(tickets1 + tickets2 + tickets3):(ticket'=3);
    [serve3] job3=true & ticket=3 -> tickets1/(tickets1 + tickets2 + tickets3):(ticket'=1) + tickets2/(tickets1 + tickets2 + tickets3):(ticket'=2) + tickets3/(tickets1 + tickets2 + tickets3):(ticket'=3);

    // Draw new (different) tickets if current ticket does not have a job
    [] ticket=1 & job1=false -> tickets2/(tickets2 + tickets3):(ticket'=2) + tickets3/(tickets2 + tickets3):(ticket'=3);
    [] ticket=2 & job2=false -> tickets1/(tickets1 + tickets3):(ticket'=1) + tickets3/(tickets1 + tickets3):(ticket'=3);
    [] ticket=3 & job3=false -> tickets1/(tickets1 + tickets2):(ticket'=1) + tickets2/(tickets1 + tickets2):(ticket'=2);
    

    // Complete any job that has finished
    [finish1] job1=true -> (job1'=false);
    [finish2] job2=true -> (job2'=false);
    [finish3] job3=true -> (job3'=false);
endmodule