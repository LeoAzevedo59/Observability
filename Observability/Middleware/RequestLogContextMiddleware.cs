using Serilog.Context;

namespace Observability.Middleware
{
    public class RequestLogContextMiddleware(RequestDelegate next)
    {
        private readonly RequestDelegate _next = next;

        public Task InvokeAsync(HttpContext context)
        {
            using (LogContext.PushProperty("CorrelationId", context.TraceIdentifier))
            {
                return _next(context);
            }
        }
    }
}

