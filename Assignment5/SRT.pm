mdp

module client1
    state1 : [0..1] init 0; // State of the job (inactive/active)
    task1  : [0..5] init 0; // Length of the job
    
    // Create a new job - length chose non-deterministically
    [create1] state1=0 -> (state1'=1) & (task1'=1);
    [create1] state1=0 -> (state1'=1) & (task1'=2);
    [create1] state1=0 -> (state1'=1) & (task1'=3);
    [create1] state1=0 -> (state1'=1) & (task1'=4);
    [create1] state1=0 -> (state1'=1) & (task1'=5);

    // Serve the job
    [serve1] state1=1 & task1>0 -> (task1'=task1-1);

    // Complete the job
    [finish1] state1=1 & task1=0 -> (state1'=0);

endmodule

module client2 = client1 [state1=state2,
                          task1=task2,
                          create1=create2,
                          serve1=serve2,
                          finish1=finish2 ]
endmodule

module scheduler
  	job1 : bool init false; // Is there a job from client1?
  	job2 : bool init false; // Is there a job from client2?
	next : [1..2] init 1;
	// Record that there is a waiting job
	[create1] job1=false -> (job1'=true);
	[create2] job2=false -> (job2'=true);

	// Serve the job that has the least remaining time
	[serve1] (job1=true & next=1) | job2=false -> (next'=2);
	[serve2] (job2=true & next=2) | job1=false -> (next'=1);

	// Complete any job that has finished
	[finish1] job1=true -> (job1'=false);
	[finish2] job2=true -> (job2'=false);

endmodule

system
  scheduler || client1 || client2
endsystem
