__TIMERS = {}

function Timer_Start(id)
    __TIMERS[id] = os.clock()
end

function Timer_Stop(id)
    return os.clock() - __TIMERS[id]
end

__BENCHMARKS = {}

function Benchmark(id, func)
    local starttime = os.clock()
    func()
    __BENCHMARKS[id] = os.clock() - starttime
end

function PrintBenchmarks()
    for k, v in pairs(__BENCHMARKS) do
        print(k..": "..v.." secs")
    end
end

--[[!! LEAVE TWO CARRIAGE RETURNS AFTER SOURCE FILE !!]]--

