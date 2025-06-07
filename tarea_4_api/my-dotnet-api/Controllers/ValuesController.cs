using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;

namespace my_dotnet_api.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ValuesController : ControllerBase
    {
        // GET: /values
        [HttpGet]
        public ActionResult<IEnumerable<string>> Get()
        {
            return new string[] { "value1", "value2" };
        }

        // POST: /values
        [HttpPost]
        public ActionResult Post([FromBody] string value)
        {
            // Logic to handle the posted value
            return CreatedAtAction(nameof(Get), new { id = value }, value);
        }
    }
}