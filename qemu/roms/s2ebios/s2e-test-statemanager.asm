[bits 32]

msg_sm: db "FAILED - Must have only one state after the barrier", 0
msg_sminst: db "FAILED - Must have only one instance after the barrier", 0

s2e_sm_test:

    push 4
    call s2e_fork_depth
    add esp, 4

    call s2e_sm_succeed

    ;Wait for the state to stabilize
    ;(it takes a while for all processes to be killed)
    push 3
    call s2e_sleep
    add esp, 4

    ;At this point, there can be only one state
    call s2e_get_state_count
    cmp eax, 1
    je sst1

    ;We must have only one state at this point
    push msg_sm
    push eax
    call s2e_kill_state

sst1:

    ;We must have only one S2E instance
    call s2e_get_proc_count
    cmp eax, 1
    je sst2

    push msg_sminst
    push eax
    call s2e_kill_state

sst2:

    ;Finish the test
    push msg_ok
    push 0
    call s2e_kill_state
    add esp, 8
    ret




