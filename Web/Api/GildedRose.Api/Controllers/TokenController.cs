﻿using GildedRose.Api.Models;
using GildedRose.Api.Validators;
using GildedRose.Membership;
using GildedRose.Membership.Models;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace GildedRose.Api.Controllers
{
    [Route("api/[controller]")]
    public class TokenController : Controller
    {
        private IdentityHelper auth;
        private CreateAccountModel_Validator validateCreateAccount;
        private LoginModel_Validator validateLogin;

        public TokenController(
            IdentityHelper auth,
            CreateAccountModel_Validator validateCreateAccount,
            LoginModel_Validator validateLogin
            )
        {
            this.auth = auth;
            this.validateCreateAccount = validateCreateAccount;
            this.validateLogin = validateLogin;
        }

        [HttpPost]
        [Route("createtoken")]
        public async Task<IActionResult> CreateToken([FromBody]LoginModel login)
        {
            var result = await this.validateLogin.ValidateAsync(login);
            if (!result.IsValid)
            {
                var errorResponse = new List<ResponseError>();
                foreach (var error in result.Errors)
                {
                    errorResponse.Add(
                        new ResponseError()
                        {
                            Field = error.PropertyName,
                            ErrorMessage = error.ErrorMessage,
                            InputData = error.AttemptedValue,
                        });
                }

                return this.BadRequest(errorResponse);
            }

            IActionResult response = this.Unauthorized();
            var user = await this.auth.Authenticate(login);

            if (user != null)
            {
                var tokenString = this.auth.BuildToken(user);
                response = this.Ok(new { token = tokenString });
            }

            return response;
        }

        [HttpPost]
        [Route("createaccount")]
        public async Task<IActionResult> CreateAccount([FromBody]CreateAccountModel newAccount)
        {
            var result = await this.validateCreateAccount.ValidateAsync(newAccount);
            if (!result.IsValid)
            {
                var errorResponse = new List<ResponseError>();
                foreach (var error in result.Errors)
                {
                    errorResponse.Add(
                        new ResponseError()
                        {
                            Field = error.PropertyName,
                            ErrorMessage = error.ErrorMessage,
                            InputData = error.AttemptedValue,
                        });
                }

                return this.BadRequest(errorResponse);
            }

            if (await this.auth.CreateAccount(newAccount) != 0)
            {
                return this.Ok(new { message = "User Account has been created successfully." });
            }

            return this.BadRequest(new { message = "Account Could not be created, please try again later." });
        }
    }
}