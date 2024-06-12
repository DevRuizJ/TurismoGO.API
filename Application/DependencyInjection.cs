﻿using Application.Shared.Commands;
using Microsoft.Extensions.DependencyInjection;

namespace Application
{
    public static class DependencyInjection
    {
        public static IServiceCollection AddApplication(this IServiceCollection services)
        {
            //commands
            services.AddCommands();

            return services;
        }
    }
}
