def print_div_full(n):
    for i in range(1, n):
        print(f"tickets{i}/(",end="")
        for j in range(1, n):
            print(f"tickets{j} + ",end="")
        print(f"tickets{n}):(ticket'={i}) + ", end="")
    print(f"tickets{n}/(",end="")
    for j in range(1, n):
        print(f"tickets{j} + ",end="")
    print(f"tickets{n}):(ticket'={n});")

def print_div_half(n, k):
    for i in range(1, n):
        if k == i:
            continue
        print(f"tickets{i}/(",end="")
        nums = [val for val in range(1, n + 1)]
        nums.remove(k)
        for j in range(len(nums) - 1):
            print(f"tickets{nums[j]} + ",end="")
        if k == n and i == n - 1:
            print(f"tickets{nums[len(nums) - 1]}):(ticket'={i});", end="")
        else:
            print(f"tickets{nums[len(nums) - 1]}):(ticket'={i}) + ", end="")
            
    if k == n:
        return
    print(f"tickets{n}/(",end="")
    nums = [val for val in range(1, n + 1)]
    nums.remove(k)
    for j in range(len(nums) - 1):
        print(f"tickets{nums[j]} + ",end="")
    print(f"tickets{nums[len(nums) - 1]}):(ticket'={n});", end="")
    print()

n = 7

print("""dtmc

const int t;

module monitor
    finished : bool init false;
    [finish1] true -> (finished'=true);
endmodule

module client1
    state1 : [0..1] init 0; // State of the job (inactive/active)
    task1  : [0..5] init 0; // Length of the job
    tickets1 : [1..100000] init 1;
    
    // Create a new job - length chose non-deterministically
    [create1] state1=0 -> (state1'=1) & (task1'=1) & (tickets1'=10000);
    [create1] state1=0 -> (state1'=1) & (task1'=2) & (tickets1'=1000);
    [create1] state1=0 -> (state1'=1) & (task1'=3) & (tickets1'=100);
    [create1] state1=0 -> (state1'=1) & (task1'=4) & (tickets1'=10);
    [create1] state1=0 -> (state1'=1) & (task1'=5) & (tickets1'=1);

    // Serve the job
    [serve1] state1=1 & task1>0 -> (task1'=task1-1) & (tickets1'=tickets1*10);

    // Complete the job
    [finish1] state1=1 & task1=0 -> (state1'=0);

endmodule""")

for i in range(2, n+1):
    print(f"module client{i} = client1 [state1=state{i},task1=task{i},create1=create{i},serve1=serve{i},finish1=finish{i},tickets1=tickets{i} ]")
    print("endmodule")
print()

print("module scheduler")
for i in range(1,n+1):
    print(f"job{i} : bool init false;")

print()
print(f"ticket : [0..{n}] init 0;")
print()
for i in range(1,n+1):
    print(f"[create{i}] job{i}=false -> (job{i}'=true);")

print()
for i in range(1, n+1):
    print(f"[serve{i}] job{i}=true & ticket={i} -> ", end="")
    print_div_full(n)

print()
for i in range(1, n+1):
    print(f"[] ticket={i} & job{i}=false -> ",end="")
    print_div_half(n, i)
    print()

print()
for i in range(1, n+1):
    print(f"[finish{i}] job{i}=true -> (job{i}'=false);")
print("endmodule")