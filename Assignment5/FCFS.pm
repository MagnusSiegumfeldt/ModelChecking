mdp

module client1
  state1    : [0..1] init 0; // State of the job (inactive/active)
  task1     : [0..5] init 0; // Length of the job
  priority1 : [0..1] init 0;
  
  // Create a new job - length and priority chosen non-deterministically
  [create1] state1=0 -> (state1'=1) & (priority1'=0) & (task1'=1);
  [create1] state1=0 -> (state1'=1) & (priority1'=0) & (task1'=2);
  [create1] state1=0 -> (state1'=1) & (priority1'=0) & (task1'=3);
  [create1] state1=0 -> (state1'=1) & (priority1'=0) & (task1'=4);
  [create1] state1=0 -> (state1'=1) & (priority1'=0) & (task1'=5);
  [create1] state1=0 -> (state1'=1) & (priority1'=1) & (task1'=1);
  [create1] state1=0 -> (state1'=1) & (priority1'=1) & (task1'=2);
  [create1] state1=0 -> (state1'=1) & (priority1'=1) & (task1'=3);
  [create1] state1=0 -> (state1'=1) & (priority1'=1) & (task1'=4);
  [create1] state1=0 -> (state1'=1) & (priority1'=1) & (task1'=5);

  // Serve the job
  [serve1] state1=1 & task1>0 -> (task1'=task1-1);

  // Complete the job
  [finish1] state1=1 & task1=0 -> (state1'=0);

endmodule

module client2 = client1 [state1=state2,
                          task1=task2,
                          create1=create2,
                          serve1=serve2,
                          finish1=finish2,
                          priority1=priority2]
endmodule

module scheduler
  job1 : [0..2] init 0; // First job in the queue
  job2 : [0..2] init 0; // Second job in the queue

  // Place a new job at the end of the queue
  [create1] job2=0 -> (job2'=1);
  [create2] job2=0 -> (job2'=2);

  // Shift the queue if there is an empty slot
  [] job1=0 & job2>0 -> (job1'=job2) & (job2'=0);

  // Swap places if the two jobs in queue are in the wrong order w.r.t their priority
  [] job1=1 & job2=2 & (priority1 < priority2) -> (job1'=2) & (job2'=1);
  [] job1=2 & job2=1 & (priority2 < priority1) -> (job1'=1) & (job2'=2);

  // Serve the job at the head of the queue if it has the highest priority
  [serve1] job1=1 & (priority1 >= priority2) -> true; 
  [serve2] job1=2 & (priority2 >= priority1) -> true;

  // Complete the job at the head of the queue
  [finish1] job1=1 -> (job1'=0);
  [finish2] job1=2 -> (job1'=0);

endmodule

system
  scheduler || client1 || client2
endsystem

